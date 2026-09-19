import Foundation
#if canImport(llama)
import llama
actor LlamaNativeBackend:LocalLLMBackend{
 private let modelURL:URL
 init(modelURL:URL){self.modelURL=modelURL}
 func generate(prompt:String) async throws -> String{
  llama_backend_init()
  defer{llama_backend_free()}
  var mp=llama_model_default_params();mp.n_gpu_layers=99
  guard let model=llama_model_load_from_file(modelURL.path,mp) else{throw LocalLLMError.loadFailed}
  defer{llama_model_free(model)}
  let vocab=llama_model_get_vocab(model)
  let cap=max(2048,prompt.utf8.count+32);var tokens=[llama_token](repeating:0,count:cap)
  let count=prompt.withCString{llama_tokenize(vocab,$0,Int32(strlen($0)),&tokens,Int32(tokens.count),true,true)}
  guard count>0 else{throw LocalLLMError.inferenceFailed};tokens=Array(tokens.prefix(Int(count)))
  var cp=llama_context_default_params();cp.n_ctx=2048;cp.n_batch=512
  guard let ctx=llama_init_from_model(model,cp) else{throw LocalLLMError.loadFailed};defer{llama_free(ctx)}
  var batch=llama_batch_get_one(&tokens,Int32(tokens.count))
  guard llama_decode(ctx,batch)==0 else{throw LocalLLMError.inferenceFailed}
  let chain=llama_sampler_chain_init(llama_sampler_chain_default_params());defer{llama_sampler_free(chain)}
  llama_sampler_chain_add(chain,llama_sampler_init_temp(0.7));llama_sampler_chain_add(chain,llama_sampler_init_dist(UInt32.random(in:1...UInt32.max)))
  var out="";for _ in 0..<256{let id=llama_sampler_sample(chain,ctx,-1);if llama_vocab_is_eog(vocab,id){break};var b=[CChar](repeating:0,count:256);let n=llama_token_to_piece(vocab,id,&b,Int32(b.count),0,true);if n>0{out+=String(decoding:b.prefix(Int(n)).map{UInt8(bitPattern:$0)},as:UTF8.self)};var one=[id];batch=llama_batch_get_one(&one,1);if llama_decode(ctx,batch) != 0{break}}
  return out.trimmingCharacters(in:.whitespacesAndNewlines)
 }
}
#else
actor LlamaNativeBackend:LocalLLMBackend{init(modelURL:URL){};func generate(prompt:String) async throws->String{throw LocalLLMError.backendUnavailable}}
#endif

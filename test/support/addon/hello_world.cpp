#include <nan.h>

NAN_METHOD(Method) {
	NanScope();
	NanReturnValue(NanNew<v8::String>("hello, world"));
}

void init(v8::Handle<v8::Object> exports) {
	exports->Set(NanNew<v8::String>("helloWorld"),
		NanNew<v8::FunctionTemplate>(Method)->GetFunction());
}

NODE_MODULE(hello_world, init)

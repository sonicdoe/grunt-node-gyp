#include <nan.h>

NAN_METHOD(Method) {
	info.GetReturnValue().Set(Nan::New<v8::String>("hello, world").ToLocalChecked());
}

NAN_MODULE_INIT(init) {
	Nan::Set(target, Nan::New<v8::String>("helloWorld").ToLocalChecked(),
		Nan::GetFunction(Nan::New<v8::FunctionTemplate>(Method)).ToLocalChecked());
}

NODE_MODULE(hello_world, init)

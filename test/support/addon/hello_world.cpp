#include <node.h>
#include <v8.h>

v8::Handle<v8::Value> Method(const v8::Arguments& args) {
	v8::HandleScope scope;

	return scope.Close(v8::String::New("hello, world"));
}

void init(v8::Handle<v8::Object> exports) {
	exports->Set(v8::String::NewSymbol("helloWorld"),
		v8::FunctionTemplate::New(Method)->GetFunction());
}

NODE_MODULE(hello_world, init)

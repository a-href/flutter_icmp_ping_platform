import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';

/** FlutterIcmpPingPlugin **/
export default class FlutterIcmpPingPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "FlutterIcmpPingPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_icmp_ping");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }
  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "start") {
     result.notImplemented()
    }else if(call.method == "stop"){
     result.notImplemented()
    }else{
      result.notImplemented()
    }
  }
}
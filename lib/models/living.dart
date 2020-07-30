class Living {
  String callerId;
  String callerName;
  String callerPic;
  String channelId;
  bool hasDialled;

  Living({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.channelId,
    this.hasDialled = false,
  });

  Map<String, dynamic> toMap(Living call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["caller_pic"] = call.callerPic;

    callMap["channel_id"] = call.channelId;
    callMap["hasDialled"] = call.hasDialled;
    return callMap;
  }

  Living.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"];
    this.callerName = callMap["caller_name"]; 
    this.callerPic = callMap["caller_pic"];  
    this.channelId = callMap["channel_id"]; 
    this.hasDialled = callMap["hasDialled"]; 
  }
}

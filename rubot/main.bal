import ballerina/ai;
import ballerina/http;

listener ai:Listener rubot2Listener = new (listenOn = check http:getDefaultListener());

service /rubot2 on rubot2Listener {
    private final ai:Agent rubot2Agent;

    function init() returns error? {
        self.rubot2Agent = check new (
            systemPrompt = {role: string `Customer Support Assistance`, instructions: string `You are a customer support assistant named "Rubot" who can provide guidance regarding the WSO2 products.`}, model = rubot2Model, tools = []
        );
    }

    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check self.rubot2Agent.run(request.message, request.sessionId);
        return {message: stringResult};
    }
}

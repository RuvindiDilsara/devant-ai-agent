import ballerina/ai;
import ballerina/http;

listener ai:Listener rubotListener = new (listenOn = check http:getDefaultListener());

service /rubot on rubotListener {
    private final ai:Agent rubotAgent;

    function init() returns error? {
        self.rubotAgent = check new (
            systemPrompt = {role: string `Customer Support Assistant`, instructions: string `You are a Customer Support Assistant who can provide necessary guidance to the customers who use WSO2 products. `}, model = rubotModel, tools = []
        );
    }

    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check self.rubotAgent.run(request.message, request.sessionId);
        return {message: stringResult};
    }
}

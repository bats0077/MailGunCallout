@isTest
global class ExampleCalloutMock implements HttpCalloutMock {
    String status;
    global ExampleCalloutMock (String status) {
        this.status = status;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        
        if(this.status == 'Success'){
            res.setStatusCode(200);
        }
        else{
            res.setStatusCode(500);
        }
        
        return res;
    }
}
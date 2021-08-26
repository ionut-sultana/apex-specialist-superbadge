@IsTest 
global class WarehouseCalloutServiceMock implements HttpCalloutMock{
    
    @TestVisible static Boolean insertBadContent = null;

    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://th-superbadge-apex.herokuapp.com/equipment', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(insertBadContent){
            res.setBody('[{"some":"text"}]');
        } else {
            res.setBody('[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"},{"_id":"55d66226726b611100aaf743","replacement":true,"quantity":143,"name":"Fuse 20A","maintenanceperiod":0,"lifespan":0,"cost":22,"sku":"100005"},{"_id":"55d66226726b611100aaf744","replacement":false,"quantity":5,"name":"Generator 2000 kw","maintenanceperiod":365,"lifespan":120,"cost":6000,"sku":"100006"},{"_id":"55d66226726b611100aaf745","replacement":true,"quantity":142,"name":"Fuse 25A","maintenanceperiod":0,"lifespan":0,"cost":28,"sku":"100007"},{"_id":"55d66226726b611100aaf746","replacement":true,"quantity":122,"name":"Fuse 13A","maintenanceperiod":0,"lifespan":0,"cost":10,"sku":"100008"},{"_id":"55d66226726b611100aaf747","replacement":true,"quantity":90,"name":"Ball Valve 10 cm","maintenanceperiod":0,"lifespan":0,"cost":50,"sku":"100009"}]');
        }
        res.setStatusCode(200);
        return res;
    }
}
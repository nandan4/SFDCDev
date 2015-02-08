global class MockGeocodeResponseGenerator implements HttpCalloutMock { 

global HTTPResponse respond(HTTPRequest req) { 

HttpResponse res = new HttpResponse(); 
res.setHeader('Content-Type', 'application/json'); 
res.setBody('{"authenticationResultCode":"ValidCredentials","brandLogoUri":"http://dev.virtualearth.net/Branding/logo_powered_by.png <http:/.////dev.virtualearth.net//Branding//logo_powered_by.png> ","copyright":"Copyright © 2014 Microsoft and its suppliers. All rights reserved. This API cannot be accessed and the content and any resultsmay not be used, reproduced or transmitted in any manner without express written permission from Microsoft Corporation.","resourceSets":[{"estimatedTotal":1,"resources":[{"__type":"Location:http://schemas.microsoft.com/search/local/ws/rest/v1 <http:/.////schemas.microsoft.com//search//local//ws//rest//v1> ","bbox":[12.8477001,77.6753693,12.8487797,77.6777496],"name":"Electronic City Phase 2, Electronics City, Bangalore 560100, India","point":{"type":"Point","coordinates":[12.8482599,77.6765518]},"address":{"addressLine":"Electronic City Phase 2","adminDistrict":"Karnataka","adminDistrict2":"Bengaluru","countryRegion":"India","formattedAddress":"Electronic City Phase 2, Electronics City,Bangalore 560100, India","locality":"Bangalore","postalCode":"560100"},"confidence":"Medium","entityType":"RoadBlock","geocodePoints":[{"type":"Point","coordinates":[12.8482599,77.6765518],"calculationMethod":"InterpolationOffset","usageTypes":["Display"]},{"type":"Point","coordinates":[12.8482599,77.6765518],"calculationMethod":"Interpolation","usageTypes":["Route"]}],"matchCodes":["Good","UpHierarchy"]}]}],"statusCode":200,"statusDescription":"OK","traceId":"74b719a2dfb5477da6ab2a63dfc6e906&#124;BN20320521&#124;02.00.106.800&#124;BN2SCH020131329, i-369dc3dd.us-east-1c"}'); 

res.setStatusCode(200); 
return res; 
} 
}
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'main.dart';
const host="http://srv.msb-co.ir/tools/";
const hostSsl="https://msb-co.ir/srv/tools/";
const admin="admins.php";
const sales="msb925sales.php";
const sell="msb925Sell.php";
const ordersUrl="loadOrders.php";
const addOrderUrl="addOrders.php";
const projectListUrl="loadProjectList.php";
const dbWorkUrl="dbWork.php";
const updateOrderUrl="updateOrder.php";
const dbQueryUrl="dbQuery.php";
const uploadUrl="https://msb-co.ir/srv/tools/upload.php";
const otpUrl = 'v1/356C5763506A62304B6B78447235337855495265784851414C6F33362B557A6F484559345A5847434878493D/verify/lookup.json';
const dbDeleteAction='delete';
const dbUpdateAction='update';
const dbInsertAction='insert';
const otpHost ='http://api.kavenegar.com/v1/356C5763506A62304B6B78447235337855495265784851414C6F33362B557A6F484559345A5847434878493D/verify/lookup.json';
const otpHostSsl ='https://api.kavenegar.com/v1/356C5763506A62304B6B78447235337855495265784851414C6F33362B557A6F484559345A5847434878493D/verify/lookup.json';
void launchURLLink(String url) async {
    if (!await launchUrlString(url)) throw 'Could not launch $url';
}


Future<void> postReq(String host,String hostSsl, String url,var body,void Function(int status, String body) handle) async {
    final client = RetryClient(http.Client(),retries: 3);
    http.Response response;
    var s=100;
    var b='ERR';
    try {
        var link = Uri.parse('$hostSsl$url');
        logD(link);
        logD('ssllllllllll: $link');
        response = await client.post(link,body: body);
        s=response.statusCode;
        b=response.body;
        //print(b);
    } catch(e) {
        var link = Uri.parse('$host$url');
        //print('nonssllllllllll: $link');
        //print('SSL ERR: $e');
        try {
            response = await client.post(link, body: body);
            s=response.statusCode;
            b=response.body;
            //print(b);
        }catch(e) {
            //print('HTTP ERR: $e');
            logD(e);
            b=e.toString();
            handle(s,e.toString());
        }
    }finally {
        client.close();
        handle(s,b);
    }
    //
}

void dbQuery(table,res){
    var body={
        'mobile':'9107446137',
        'password':'pooria3128',
        'table':table
    };
    postReq(host, hostSsl, dbQueryUrl, body, res);
}

void dbInsert(body,id,table,res){
    _dbWork(body, dbInsertAction, id, table, res);
}

void dbDelete(id,table,res){
    _dbWork('', dbDeleteAction, id, table, res);
}

void dbUpdate(body,id,table,res){
    _dbWork(body, dbUpdateAction, id, table, res);
}

void _dbWork(body,action,id,table,res){
    // $id = $_REQUEST['id'];
    // $table = $_REQUEST['table'];
    // $body = $_REQUEST['body'];
    // $action = $_REQUEST['action'];

    // var reqBody={
    //     'mobile': _user['mobile'],
    //     'password': _user['pass'],
    //     'id': _title,
    //     'action': 'update',
    //     'table': 'partOrders',
    //     'body': jsonEncode(newBody),
    // };

    var b={
        'mobile':'9107446137',
        'password':'pooria3128',
        'table':table,
        'body':jsonEncode(body),
        'action':action,
        'id':id
    };
    postReq(host, hostSsl, dbWorkUrl, b, res);
}


Future<void> uploadReq(String url,String mobile,String pass,String filePath,String path,void Function(int status, String body) handle)async{
    var req=http.MultipartRequest("POST", Uri.parse(url));
    req.fields["mobile"] = mobile;
    req.fields["password"] = pass;
    req.fields["path"] = path;
    var f = await http.MultipartFile.fromPath("file", filePath);
    if (kDebugMode) {
      print(f.length);
    }
    req.files.add(f);
    var response = await req.send();
    var responseData = await response.stream.toBytes();
    handle(response.statusCode,String.fromCharCodes(responseData));
    //print("Response: $responseString");

}
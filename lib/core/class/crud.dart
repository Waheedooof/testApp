import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:test_maker/core/class/statusrequest.dart';
import '../function/checkinternet.dart';

class Crud {
  Future<Either<StatusRequest, Map>> postData(String urlLink, Map data) async {
    try {
      if (await checkInternet()) {
        var response = await http.post(Uri.parse(urlLink), body: data);
        print('==========Crud================');
        print(response.statusCode);
        print(response.body.toString());
        print(data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responceBody = jsonDecode(response.body);
          print('==========responceBody.length================');
          return Right(responceBody);
        } else {
          return const Left(StatusRequest.failure);
        }
      } else {
        return const Left(StatusRequest.offline);
      }
    } catch (_) {
      return const Left(StatusRequest.serverExp);
    }
  }

  Future<Either<StatusRequest, Map>> sendImageList(
      String urlLink, List<String> imageList) async {
    var requestBody = {'imageList': imageList};
    try {
      if (await checkInternet()) {
        var response = await http.post(
          Uri.parse(urlLink),
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          // if (response.body.toString().contains('Image deleted successfully')) {
          // } else {}
          return Right(jsonDecode(response.body));
        }  else {
          return const Left(StatusRequest.failure);
        }
      } else {
        return const Left(StatusRequest.offline);
      }
    } catch (_) {
      return const Left(StatusRequest.serverExp);
    }
  }

  Future<Either<StatusRequest, String>> postDataWithImage(
    String urlLink,
    Map data,
    File file,
  ) async {
    try {
      if (await checkInternet()) {
        var request = http.MultipartRequest('POST', Uri.parse(urlLink));
        var length = await file.length();
        var stream = http.ByteStream(file.openRead());
        var multiparFile = http.MultipartFile('file', stream, length,
            filename: basename(file.path));
        request.files.add(multiparFile);
        data.forEach((key, value) {
          request.fields[key] = value;
          print(key + ':' + value);
        });
        var myreq = await request.send();

        var response = await http.Response.fromStream(myreq);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Map responceBody = jsonDecode(response.body);
          return Right(response.body);
        } else {
          return const Left(StatusRequest.failure);
        }
      } else {
        return const Left(StatusRequest.offline);
      }
    } catch (_) {
      return const Left(StatusRequest.serverExp);
    }
  }
}

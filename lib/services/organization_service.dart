// organization_service/organization_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class OrganizationService {
  final String baseUrl = 'http://34.64.165.164:8080/api/organizations/my';

  // 조직 목록 조회
  Future<List<dynamic>> fetchOrganizations(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final String decodeBody = utf8.decode(response.bodyBytes);  //utf8 수동 디코딩
      final Map<String,dynamic> data = jsonDecode(decodeBody); 
      print("response값은: $data");
      return data['data'] as List<dynamic>;
    } else {
      throw Exception('조직 데이터를 불러올 수 없습니다.');
    }
  }

  //조직 조회
  Future<List<dynamic>> searchOrganization(
    String token, String keyword, int page, int size) async {
  final queryParameters = {
    'keyword': keyword,
    'page': page.toString(),
    'size': size.toString(),
  };

  final url = Uri.http(
      '34.64.165.164:8080', '/api/organizations/search', queryParameters);

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final String decodeBody = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> data = jsonDecode(decodeBody);
    final List<dynamic> organizations = data['data'] as List<dynamic>;
    print("service에서 organizations는: $organizations");
    return organizations; // 전체 조직 데이터를 반환
  } else {
    throw Exception('조직 검색에 실패했습니다.');
  }
}

  //조직 생성
  Future<void> createOrganizations(
      String token, String name, String description) async {
    final response = await http.post(
      Uri.parse('http://34.64.165.164:8080/api/organizations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'organization_name': name,
        'description': description,
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      // 조직 생성이 성공한 후 조직 목록을 다시 불러옴
      fetchOrganizations(token);
    } else {
      throw Exception('조직 생성에 실패했습니다.');
    }
  }
}

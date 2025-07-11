import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tap_invest_assignment/model/company_details.dart';
import 'package:tap_invest_assignment/model/company_model.dart';

abstract class CompanyRepository {
  Future<List<CompanyModel>> fetchCompany();

  Future<CompanyDetails> fetchCompanyDetails();
}

class CompanyRepositoryImpl implements CompanyRepository {
  @override
  Future<List<CompanyModel>> fetchCompany() async {
    try {
      final response = await http.get(
        Uri.parse('https://eol122duf9sy4de.m.pipedream.net'),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final list = decoded['data'] as List;
        return list.map((e) => CompanyModel.fromJson(e)).toList();
      } else {
        throw Exception(
            "Failed to fetch company list: HTTP ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<CompanyDetails> fetchCompanyDetails() async {
    try {
      final response = await http.get(
        Uri.parse("https://eo61q3zd4heiwke.m.pipedream.net"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return CompanyDetails.fromJson(data);
      } else {
        throw Exception(
            "Failed to fetch company details: HTTP ${response.statusCode}");
      }
    } on Exception catch (e) {
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }
}

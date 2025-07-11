import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_invest_assignment/bloc/company_state.dart';
import 'package:tap_invest_assignment/model/company_model.dart';
import 'package:tap_invest_assignment/repository/company_repository.dart';

class CompanyCubit extends Cubit<CompanyState>{
final CompanyRepository repository;
List<CompanyModel> _allcompanyList = [];

CompanyCubit(this.repository):super(const CompanyState.initial());

Future<void> fetchIssuers() async {
  emit(const CompanyState.loading());
  try {
    _allcompanyList = await repository.fetchCompany();
    emit(CompanyState.loaded(allCompany: _allcompanyList, filteredCompany: _allcompanyList));
  } catch (e) {
    emit(CompanyState.failure(e.toString()));
  }
}

void search(String query) {
  // if (state is CompanyState.loading() ) return;
  if (query.isEmpty) {
    emit(CompanyState.loaded(allCompany: _allcompanyList, filteredCompany: _allcompanyList));
    return;
  }

  final filtered = _allcompanyList.where((issuer) {
    final lowerQuery = query.toLowerCase();
    return issuer.isin.toLowerCase().contains(lowerQuery) ||
        issuer.companyName.toLowerCase().contains(lowerQuery) ||
        issuer.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }).toList();

  emit(CompanyState.loaded(allCompany: _allcompanyList, filteredCompany: filtered));
}


}
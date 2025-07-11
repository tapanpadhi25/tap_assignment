import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_invest_assignment/bloc/company_details_state.dart';
import 'package:tap_invest_assignment/model/company_details.dart';
import 'package:tap_invest_assignment/repository/company_repository.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  final CompanyRepository repository;
  CompanyDetails? _companyDetails;

  CompanyDetailsCubit(this.repository)
      : super(const CompanyDetailsState.initial());

  Future<void> fetchCompanyDetails() async {
    emit(const CompanyDetailsState.loading());
    try {
      _companyDetails = await repository.fetchCompanyDetails();
      emit(CompanyDetailsState.loaded(companyDetails: _companyDetails!));
    } catch (e) {
      emit(CompanyDetailsState.failure(e.toString()));
    }
  }
}

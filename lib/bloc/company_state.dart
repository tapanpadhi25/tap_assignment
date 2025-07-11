import 'package:freezed_annotation/freezed_annotation.dart';
import '../model/company_model.dart';
part 'company_state.freezed.dart';

@freezed
class CompanyState with _$CompanyState {
  const factory CompanyState.initial() = _Initial;
  const factory CompanyState.loading() = _Loading;
  const factory CompanyState.loaded({
    required List<CompanyModel> allCompany,
    required List<CompanyModel> filteredCompany,
  }) = _Loaded;
  const factory CompanyState.failure(String error) = _Failure;
}

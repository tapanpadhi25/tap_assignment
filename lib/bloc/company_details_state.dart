import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tap_invest_assignment/model/company_details.dart';
part 'company_details_state.freezed.dart';

@freezed
class CompanyDetailsState with _$CompanyDetailsState {
  const factory CompanyDetailsState.initial() = _Initial;
  const factory CompanyDetailsState.loading() = _Loading;
  const factory CompanyDetailsState.loaded({
    required CompanyDetails companyDetails,

  }) = _Loaded;
  const factory CompanyDetailsState.failure(String error) = _Failure;
}

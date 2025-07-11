import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../repository/company_repository.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.registerLazySingleton<CompanyRepository>(() => CompanyRepositoryImpl());
}

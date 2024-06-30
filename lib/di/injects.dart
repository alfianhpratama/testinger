import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:testinger/di/injects.config.dart';

final inject = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies() =>
    inject.init(environmentFilter: const NoEnvOrContainsAny({}));

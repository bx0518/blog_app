part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  // Supabase Initialization
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // Sqflite Initialization
  final db = await AppDatabase().init();
  serviceLocator.registerLazySingleton(() => db);

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerFactory<UserSignUp>(
    () => UserSignUp(serviceLocator()),
  );

  serviceLocator.registerFactory<UserLogin>(() => UserLogin(serviceLocator()));

  serviceLocator.registerFactory<CurrentUser>(
    () => CurrentUser(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory<UploadBlog>(() => UploadBlog(serviceLocator()))
    ..registerFactory<GetAllBlogs>(() => GetAllBlogs(serviceLocator()))
    // Bloc
    ..registerLazySingleton<BlogBloc>(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}

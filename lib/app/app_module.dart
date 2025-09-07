import 'package:paroquia_sao_lourenco/app/app_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/home/home_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/login/login_module.dart';
import 'package:paroquia_sao_lourenco/app/modules/login/profile/profile_page.dart';
import 'package:paroquia_sao_lourenco/app/modules/login/signup_page.dart';
import 'package:paroquia_sao_lourenco/app/shared/auth/auth_repository.dart';
import 'package:paroquia_sao_lourenco/app/shared/auth/local_user.dart';
import 'package:paroquia_sao_lourenco/app/widgets/notification_test_widget.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(LocalUser.new);
    i.addLazySingleton(AuthRepository.new);
    i.addSingleton(AppController.new);
  }

  @override
  void routes(RouteManager r) {
    r.module('/', module: HomeModule());
    r.child('/signup', child: (context) => SignupPage());
    r.module('/login', module: LoginModule());
    r.child('/profile', child: (context) => ProfilePage());
    r.child('/notification-test', child: (context) => const NotificationTestWidget());
  }
}
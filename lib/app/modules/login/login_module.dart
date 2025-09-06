import 'package:paroquia_sao_lourenco/app/modules/login/profile/profile_controller.dart';
import 'package:paroquia_sao_lourenco/app/modules/login/login_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/modules/login/login_page.dart';

class LoginModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance(ProfileController());
    i.addInstance(LoginController());
  }

  @override
  void routes(RouteManager r) {
    print('LOGIN MODULE DEBUG: args.data = ${r.args.data}');
    print('LOGIN MODULE DEBUG: redirectTo = ${r.args.data?['redirectTo']}');
    r.child('/', child: (context) => LoginPage(
      redirectTo: r.args.data?['redirectTo'],
    ));
  }
}
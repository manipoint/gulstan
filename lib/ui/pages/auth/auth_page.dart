import 'package:auth/source/domain/auth_service.dart';
import 'package:auth/source/domain/credential.dart';
import 'package:auth/source/domain/signup_services.dart';
import 'package:auth/source/infa/adapters/email_auth.dart';
import 'package:auth/source/infa/mangers/auth_mangers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gulstan/models/user.dart';
import 'package:gulstan/state_mangment/auth/auth_cubit.dart';
import 'package:gulstan/state_mangment/auth/auth_state.dart';
import 'package:gulstan/ui/pages/auth/auth_page_adapter.dart';
import 'package:gulstan/ui/widgets/custom_flat_button.dart';
import 'package:gulstan/ui/widgets/custom_outline_button.dart';
import 'package:gulstan/ui/widgets/custom_text_fields.dart';

class AuthPage extends StatefulWidget {
  final AuthManager _manager;
  final ISignUpServices _signUpService;
  final IAuthPageAdapter _adapter;

  AuthPage(this._manager, this._signUpService, this._adapter);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController _controller = PageController();

  String _username = '';
  String _email = '';
  String _password = '';
  late IAuthService service;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 110.0),
                child: _buildLogo(),
              ),
              SizedBox(height: 50.0),
              BlocConsumer<AuthCubit, AuthState>(builder: (_, state) {
                return _buildUI();
              }, listener: (context, state) {
                if (state is LoadingState) {
                  _showLoader();
                }
                if (state is AuthSuccessState) {
                  widget._adapter.onAuthSuccess(context, service);
                }
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message!,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  );
                  _hideLoader();
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  _buildLogo() => Container(
        alignment: Alignment.center,
        child: Column(children: [
          SvgPicture.asset(
            'assets/logo.svg',
            fit: BoxFit.fill,
            height: 100,
            width: 180,
          ),
          SizedBox(height: 10.0),
          RichText(
            text: TextSpan(
                text: 'Gulstan',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.black,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  TextSpan(
                    text: ' Restaurant',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  )
                ]),
          )
        ]),
      );

  _buildUI() => Container(
        height: 500,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            _signIn(),
            _signUp(),
          ],
        ),
      );

  _signIn() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            ..._emailAndPassword(),
            SizedBox(height: 30.0),
            CustomFlatButton(
              text: 'Sign in',
              size: Size(double.infinity, 54.0),
              onPressed: () {
                service = widget._manager.service(AuthType.email);
                (service as EmailAuth)
                    .credential(email: _email, password: _password);
                BlocProvider.of<AuthCubit>(context)
                    .signin(service, AuthType.email);
              },
            ),
            SizedBox(height: 30.0),
            CustomOutlineButton(
              text: 'Sign in with google',
              size: Size(double.infinity, 50.0),
              icon: SvgPicture.asset(
                'assets/google-icon.svg',
                height: 18.0,
                width: 18.0,
                fit: BoxFit.fill,
              ),
              onPressed: () {
                service = widget._manager.service(AuthType.google);
                BlocProvider.of<AuthCubit>(context)
                    .signin(service, AuthType.google);
              },
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account?',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                children: [
                  TextSpan(
                    text: ' Sign up',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.elasticOut);
                      },
                  )
                ],
              ),
            )
          ],
        ),
      );

  _signUp() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            CustomTextField(
              inputAction: TextInputAction.next,
              hint: 'Username',
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              onChanged: (val) {
                _username = val;
              },
            ),
            SizedBox(height: 30.0),
            ..._emailAndPassword(),
            SizedBox(height: 30.0),
            CustomFlatButton(
              text: 'Sign up',
              size: Size(double.infinity, 54.0),
              onPressed: () {
                final user = User(
                   _username,
                   _email,
                  _password,
                );
                BlocProvider.of<AuthCubit>(context)
                    .signup(widget._signUpService, user);
              },
            ),
            SizedBox(height: 30.0),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: 'Already have an account?',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                children: [
                  TextSpan(
                    text: ' Sign in',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _controller.previousPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.elasticOut);
                      },
                  )
                ],
              ),
            )
          ],
        ),
      );

  List<Widget> _emailAndPassword() => [
        CustomTextField(
          keyboardType: TextInputType.emailAddress,
          inputAction: TextInputAction.next,
          hint: 'Email',
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          onChanged: (val) {
            _email = val;
          },
        ),
        SizedBox(height: 30.0),
        CustomTextField(
          obscure: true,
          inputAction: TextInputAction.done,
          hint: 'Password',
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          onChanged: (val) {
            _password = val;
          },
        )
      ];

  _showLoader() {
    var alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white70,
        ),
      ),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
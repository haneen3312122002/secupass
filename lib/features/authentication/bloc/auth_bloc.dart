import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/authentication/bloc/auth_event.dart';
import 'package:secupass/features/authentication/bloc/auth_state.dart';
import 'package:secupass/features/authentication/services/is_first_run.dart';
import 'package:secupass/features/home_screen/domain/entities/pin_entity.dart';
import 'package:secupass/features/home_screen/domain/usecases/pin/add_pin.dart';
import 'package:secupass/features/home_screen/domain/usecases/pin/update_pin.dart';
import 'package:secupass/features/home_screen/domain/usecases/pin/verify_pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AddPinUseCase addPin;
  final VerifyPinUseCase verifyPin;
  final UpdatePinUseCase updatePin;
  AuthBloc(this.addPin, this.updatePin, this.verifyPin)
      : super(AuthInitState()) {
    on<AuthInitEvent>((event, emit) {
      emit(AuthInitState());
    });
    on<AuthLoadingEvent>((event, emit) {
      emit(AuthLoadingState());
    });

//the first event that will be called when the app run for the first time to check if it's the first time or not and if there is a pin already or not:
    on<AuthFirstAppRunEvent>((event, emit) async {
      final isPinAlreadySet = await verifyPin.isPinSet(); // دالة جديدة

      if (!isPinAlreadySet) {
        emit(AuthFirstAppRunState()); // أظهر شاشة إضافة PIN
      } else {
        // pin is already set, so we go to the input pin screen
        emit(AuthInputPinState());
      }
    });
//when the user enter the pin and click on the button to verify it:
    on<AuthenticatedEvent>((event, emit) {
      emit(AuthenticatedState(message: event.msg));
    });

    on<AuthenticationErrorEvent>((event, emit) {
      emit(AuthenticationErrorState(error: event.errorMsg));
    });

    //add the pin to db:
    on<AddPinEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await addPin.call(event.pin);
        emit(AuthenticatedState(message: 'PIN added successfully'));
      } catch (e) {
        emit(AuthenticationErrorState(error: e.toString()));
      }
    });
    //update the pin:
    on<UpdatePinEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await updatePin.call(PinEntity(id: event.id, pin: event.pin));
        emit(AuthenticatedState(message: 'PIN updated successfully'));
      } catch (e) {
        emit(AuthenticationErrorState(error: e.toString()));
      }
    });
    //verify the pin:
    on<AuthVerifyPinEvent>(_onVerifyPin);
  }
  //......................................
  Future<void> _onVerifyPin(
      AuthVerifyPinEvent event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
// Check if the user is currently blocked due to too many failed attempts
    final blockUntil = prefs.getInt('block_until') ?? 0;
    if (now < blockUntil) {
      final remaining = ((blockUntil - now) / 1000).ceil();
      emit(AuthenticationErrorState(
          error:
              "You reached maximum tries, try again after $remaining seconds"));
      return;
    }

    emit(AuthVerifyingPinState());
    try {
      final isValid = await verifyPin(event.pin);
      if (isValid) {
        //store num of failes to 0 if the pin is true:
        prefs.setInt("failed_tries", 0); // اعادة المحاولات للصفر
        emit(AuthPinVerifiedState());
      } else {
        //add one to failes if the pin is wrong:
        int tries = prefs.getInt("failed_tries") ?? 0;
        tries++;

        if (tries >= 3) {
          final lockoutDuration = 600; // مدة الحظر بالثواني
          final lockoutTime =
              now + lockoutDuration * 1000; //to make i to miliseconds
          prefs.setInt("block_until", lockoutTime);
          prefs.setInt("failed_tries", 0);

          emit(AuthenticationErrorState(
              error: "Too many tries. Locked for 10 menuites."));
        } else {
          prefs.setInt("failed_tries", tries);
          emit(AuthenticationErrorState(
              error: "Invalid PIN. Try again ($tries/3)"));
        }
      }
    } catch (e) {
      emit(AuthenticationErrorState(error: e.toString()));
    }
  }

  //......................................
}

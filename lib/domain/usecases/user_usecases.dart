import 'package:currency_converter/infrastructure/datastore/interfaces/user_repository.dart';

class UserUseCases {
  UserUseCases({ required this.repository });
  
  final UserRepository repository;

  
}
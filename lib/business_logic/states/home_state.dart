import '../../presentation/res/strings/values.dart';

enum HomeBodyType {
  order(txtOrder),
  product(txtProduct),
  promotion(txtPromotion),
  cart(txtCart);

  final String label;

  const HomeBodyType(this.label);
}

class HomeState {
  final HomeBodyType type;

  HomeState({
    required this.type,
  });

  HomeState copyWith({
    HomeBodyType? type,
  }) {
    return HomeState(
      type: type ?? this.type,
    );
  }
}

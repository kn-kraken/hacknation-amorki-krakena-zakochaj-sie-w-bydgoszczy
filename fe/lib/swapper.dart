import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

const login = "gilewski";

// Models
class CardItem {
  final String id;
  final String title;
  final String imageUrl;

  CardItem({required this.id, required this.title, required this.imageUrl});
}

// Events
abstract class SwipeEvent {}

class SwipeRight extends SwipeEvent {
  final CardItem card;
  SwipeRight(this.card);
}

class SwipeLeft extends SwipeEvent {
  final CardItem card;
  SwipeLeft(this.card);
}

class ResetCards extends SwipeEvent {}

// State
class SwipeState {
  final List<CardItem> cards;
  final List<CardItem> likedCards;
  final List<CardItem> dislikedCards;
  final int currentIndex;

  SwipeState({
    required this.cards,
    required this.likedCards,
    required this.dislikedCards,
    required this.currentIndex,
  });

  SwipeState copyWith({
    List<CardItem>? cards,
    List<CardItem>? likedCards,
    List<CardItem>? dislikedCards,
    int? currentIndex,
  }) {
    return SwipeState(
      cards: cards ?? this.cards,
      likedCards: likedCards ?? this.likedCards,
      dislikedCards: dislikedCards ?? this.dislikedCards,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  bool get hasMoreCards => currentIndex < cards.length;
  CardItem? get currentCard => hasMoreCards ? cards[currentIndex] : null;
}

// BLoC
class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  SwipeBloc()
    : super(
        SwipeState(
          cards: _generateSampleCards(),
          likedCards: [],
          dislikedCards: [],
          currentIndex: 0,
        ),
      ) {
    on<SwipeRight>((event, emit) {
      emit(
        state.copyWith(
          likedCards: [...state.likedCards, event.card],
          currentIndex: state.currentIndex + 1,
        ),
      );
    });

    on<SwipeLeft>((event, emit) {
      emit(
        state.copyWith(
          dislikedCards: [...state.dislikedCards, event.card],
          currentIndex: state.currentIndex + 1,
        ),
      );
    });

    on<ResetCards>((event, emit) {
      emit(
        SwipeState(
          cards: _generateSampleCards(),
          likedCards: [],
          dislikedCards: [],
          currentIndex: 0,
        ),
      );
    });
  }

  static List<CardItem> _generateSampleCards() {
    return List.generate(
      10,
      (i) => CardItem(
        id: 'card_$i',
        title: 'Item ${i + 1}',
        imageUrl: 'https://picsum.photos/400/500?random=$i',
      ),
    );
  }
}

// Main App

// Screen
class SwipeCardsScreenContent extends StatelessWidget {
  const SwipeCardsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SwipeBloc>().add(ResetCards()),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SwipeBloc, SwipeState>(
              builder: (context, state) {
                if (!state.hasMoreCards) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No more cards!',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text('Liked: ${state.likedCards.length}'),
                        Text('Disliked: ${state.dislikedCards.length}'),
                      ],
                    ),
                  );
                }

                return Stack(
                  children: [
                    if (state.currentIndex + 1 < state.cards.length)
                      _buildCard(
                        context,
                        state.cards[state.currentIndex + 1],
                        false,
                      ),
                    _buildCard(
                      context,
                      state.currentCard!,
                      true,
                      key: ValueKey(state.currentCard!.id),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    CardItem card,
    bool isDraggable, {
    Key? key,
  }) {
    if (!isDraggable) {
      return Center(
        child: Container(
          width: 300,
          height: 400,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    card.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DraggableCard(key: key, card: card);
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'dislike',
            onPressed: () {
              final bloc = context.read<SwipeBloc>();
              if (bloc.state.currentCard != null) {
                bloc.add(SwipeLeft(bloc.state.currentCard!));
              }
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.close, size: 32),
          ),
          FloatingActionButton(
            heroTag: 'like',
            onPressed: () {
              final bloc = context.read<SwipeBloc>();
              if (bloc.state.currentCard != null) {
                bloc.add(SwipeRight(bloc.state.currentCard!));
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.favorite, size: 32),
          ),
        ],
      ),
    );
  }
}

// Draggable Card Widget
class DraggableCard extends StatefulWidget {
  final CardItem card;

  const DraggableCard({Key? key, required this.card}) : super(key: key);

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  Offset _position = Offset.zero;
  bool _isDragging = false;
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    final rotationAngle = _angle * pi / 180;

    return Center(
      child: GestureDetector(
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
            _angle = _position.dx / 20;
          });
        },
        onPanEnd: (details) {
          setState(() => _isDragging = false);

          if (_position.dx.abs() > 100) {
            final swipeRight = _position.dx > 0;
            _animateCardAway(swipeRight);

            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted) {
                final bloc = context.read<SwipeBloc>();
                if (swipeRight) {
                  bloc.add(SwipeRight(widget.card));
                } else {
                  bloc.add(SwipeLeft(widget.card));
                }
              }
            });
          } else {
            setState(() {
              _position = Offset.zero;
              _angle = 0;
            });
          }
        },
        child: Transform.translate(
          offset: _position,
          child: Transform.rotate(
            angle: rotationAngle,
            child: Stack(
              children: [
                Container(
                  width: 300,
                  height: 400,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            widget.card.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            widget.card.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isDragging && _position.dx.abs() > 20)
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _position.dx > 0
                            ? Colors.green.withOpacity(0.3)
                            : Colors.red.withOpacity(0.3),
                        border: Border.all(
                          color: _position.dx > 0 ? Colors.green : Colors.red,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _position.dx > 0 ? Icons.favorite : Icons.close,
                          size: 80,
                          color: _position.dx > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _animateCardAway(bool toRight) {
    final screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      _position = Offset(toRight ? screenWidth : -screenWidth, _position.dy);
    });
  }
}

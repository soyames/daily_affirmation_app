import 'package:flutter/material.dart';
import '../services/ratings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingsSummaryAndSubmit extends StatefulWidget {
  @override
  State<RatingsSummaryAndSubmit> createState() => _RatingsSummaryAndSubmitState();
}

class _RatingsSummaryAndSubmitState extends State<RatingsSummaryAndSubmit> {
  late Future<RatingSummary> _summaryFuture;
  late Future<List<AppRating>> _ratingsFuture;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _loadHasRated();
    _refresh();
  }

  Future<void> _loadHasRated() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasRated = prefs.getBool('has_rated') ?? false;
    });
  }

  void _refresh() {
    setState(() {
      _summaryFuture = RatingsService.fetchSummary();
      _ratingsFuture = RatingsService.fetchRatings();
    });
  }

  void _showRatingDialog() async {
    int selectedStars = 5;
    String comment = '';
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return _RatingDialog(
          initialStars: selectedStars,
          onSubmit: (stars, comm) async {
            final ok = await RatingsService.submitRating(stars, comm);
            if (ok) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('has_rated', true);
              setState(() {
                _hasRated = true;
                _refresh();
              });
              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to submit rating')),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<RatingSummary>(
          future: _summaryFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            if (!snap.hasData) {
              return const Text('Unable to load ratings.');
            }
            final avg = snap.data!.average;
            final count = snap.data!.count;
            return Row(
              children: [
                ...List.generate(5, (i) => Icon(
                  i < avg.round() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                )),
                const SizedBox(width: 8),
                Text(avg.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('($count ratings)'),
                const Spacer(),
                ElevatedButton(
                  onPressed: _hasRated ? null : _showRatingDialog,
                  child: Text(_hasRated ? 'Thank you!' : 'Rate'),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        const Text('Recent Reviews:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 100,
          child: FutureBuilder<List<AppRating>>(
            future: _ratingsFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.hasData) return const Text('Unable to load reviews.');
              final ratings = snap.data!;
              if (ratings.isEmpty) return const Text('No reviews yet.');
              return ListView.builder(
                itemCount: ratings.length > 5 ? 5 : ratings.length,
                itemBuilder: (context, i) {
                  final r = ratings[i];
                  return ListTile(
                    dense: true,
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (j) => Icon(
                        j < r.stars ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      )),
                    ),
                    title: Text(r.comment.isEmpty ? '(No comment)' : r.comment),
                    subtitle: Text(r.createdAt.split('T').first),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RatingDialog extends StatefulWidget {
  final int initialStars;
  final Future<void> Function(int stars, String comment) onSubmit;
  const _RatingDialog({Key? key, required this.initialStars, required this.onSubmit}) : super(key: key);

  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  late int selectedStars;
  String comment = '';

  @override
  void initState() {
    super.initState();
    selectedStars = widget.initialStars;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate this App'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => IconButton(
              icon: Icon(
                i < selectedStars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              ),
              onPressed: () {
                setState(() {
                  selectedStars = i + 1;
                });
              },
            )),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Comment (optional)',
            ),
            onChanged: (val) => comment = val,
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await widget.onSubmit(selectedStars, comment);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
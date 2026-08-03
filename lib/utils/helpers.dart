import '../data/models.dart';

String formatPrice(double price, String listing) {
  if (listing == 'rent') {
    return '\$${_formatNumber(price.toInt())}/mo';
  }
  if (price >= 1000000) {
    final millions = price / 1000000;
    if (millions == millions.truncate()) {
      return '\$${millions.truncate()}M';
    }
    return '\$${millions.toStringAsFixed(1)}M';
  }
  if (price >= 1000) {
    return '\$${_formatNumber(price.toInt())}';
  }
  return '\$${price.toInt()}';
}

String formatPriceFull(double price, String listing) {
  final formatted = '\$${_numberWithCommas(price.toInt())}';
  if (listing == 'rent') return '$formatted/mo';
  return formatted;
}

String _formatNumber(int n) {
  if (n >= 1000000) {
    return '${(n / 1000000).toStringAsFixed(1)}M';
  }
  if (n >= 1000) {
    return '${(n / 1000).toStringAsFixed(0)}K';
  }
  return n.toString();
}

String _numberWithCommas(int n) {
  return n.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]},',
  );
}

String formatArea(int area) => '$area sqft';

String formatBaths(double baths) {
  if (baths == baths.truncate()) return baths.truncate().toString();
  return baths.toString();
}

Agent? getAgent(String agentId, List<Agent> agents) {
  try {
    return agents.firstWhere((a) => a.id == agentId);
  } catch (_) {
    return null;
  }
}

String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inDays > 30) return '${(diff.inDays / 30).round()} months ago';
  if (diff.inDays > 0) return '${diff.inDays}d ago';
  if (diff.inHours > 0) return '${diff.inHours}h ago';
  return 'Just now';
}

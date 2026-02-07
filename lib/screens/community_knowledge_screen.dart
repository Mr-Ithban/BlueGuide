import 'package:flutter/material.dart';
import '../services/firebase_contribution_service.dart';

class CommunityKnowledgeScreen extends StatefulWidget {
  const CommunityKnowledgeScreen({super.key});

  @override
  State<CommunityKnowledgeScreen> createState() =>
      _CommunityKnowledgeScreenState();
}

class _CommunityKnowledgeScreenState extends State<CommunityKnowledgeScreen> {
  List<Map<String, dynamic>> _knowledge = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadKnowledge();
  }

  Future<void> _loadKnowledge() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final knowledge =
          await FirebaseContributionService.getApprovedKnowledge();
      setState(() {
        _knowledge = knowledge;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load knowledge: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _vote(String docId, bool isUpvote) async {
    try {
      if (isUpvote) {
        await FirebaseContributionService.upvoteContribution(docId);
      } else {
        await FirebaseContributionService.downvoteContribution(docId);
      }

      // Reload to show updated votes
      _loadKnowledge();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isUpvote ? '👍 Upvoted!' : '👎 Downvoted!'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error voting: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Knowledge'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadKnowledge,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadKnowledge,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _knowledge.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.library_books_outlined,
                                size: 80, color: Colors.grey[600]),
                            const SizedBox(height: 20),
                            Text('No Knowledge Yet',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700])),
                            const SizedBox(height: 10),
                            Text('Be the first to contribute!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadKnowledge,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _knowledge.length,
                        itemBuilder: (context, index) {
                          final item = _knowledge[index];
                          final title = item['title'] ?? 'Untitled';
                          final content = item['content'] ?? '';
                          final contributor =
                              item['contributorName'] ?? 'Anonymous';
                          final isScientific =
                              item['isScientificallyVerified'] ?? false;
                          final upvotes = item['upvotes'] ?? 0;
                          final downvotes = item['downvotes'] ?? 0;
                          final category = item['category'] ?? 'General';
                          final docId = item['id'];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and scientific badge
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                      if (isScientific)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('🔬',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              SizedBox(width: 4),
                                              Text('Verified',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Content
                                  Text(content,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[300])),
                                  const SizedBox(height: 12),

                                  // Category tag
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(category,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[400])),
                                  ),
                                  const SizedBox(height: 12),

                                  // Contributor and voting
                                  Row(
                                    children: [
                                      Icon(Icons.person,
                                          size: 14, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Text(contributor,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500])),
                                      const Spacer(),

                                      // Voting buttons
                                      IconButton(
                                        icon: const Icon(
                                            Icons.thumb_up_outlined,
                                            size: 20),
                                        onPressed: () => _vote(docId, true),
                                        color: Colors.green[400],
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 4),
                                      Text('$upvotes',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.green[400],
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.thumb_down_outlined,
                                            size: 20),
                                        onPressed: () => _vote(docId, false),
                                        color: Colors.red[400],
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 4),
                                      Text('$downvotes',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.red[400],
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

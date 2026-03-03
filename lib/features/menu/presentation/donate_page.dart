import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  static const Set<String> _productIds = {'tip_1000', 'tip_5000', 'tip_10000'};

  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  bool _storeAvailable = false;
  bool _isLoading = true;
  bool _isPurchasing = false;
  String? _errorMessage;
  List<ProductDetails> _products = const [];
  static const List<_FallbackProduct> _fallbackProducts = [
    _FallbackProduct(
      title: '개발자에게 기부하기',
      description: '개발자에게 1,000원 기부',
      price: '₩1,000',
    ),
    _FallbackProduct(
      title: '개발자에게 기부하기',
      description: '개발자에게 5,000원 기부',
      price: '₩5,000',
    ),
    _FallbackProduct(
      title: '개발자에게 기부하기',
      description: '개발자에게 10,000원 기부',
      price: '₩10,000',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _purchaseSubscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        if (!mounted) return;
        setState(() {
          _errorMessage = '구매 처리 중 오류가 발생했습니다: $error';
        });
      },
    );
    _loadStore();
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadStore() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (kIsWeb) {
      setState(() {
        _isLoading = false;
        _storeAvailable = false;
        _errorMessage = '웹에서는 기부 결제가 지원되지 않습니다. iOS 앱에서 이용해 주세요.';
      });
      return;
    }

    final available = await _iap.isAvailable();
    if (!mounted) return;

    if (!available) {
      setState(() {
        _isLoading = false;
        _storeAvailable = false;
        _errorMessage = 'App Store 연결이 불가능합니다. 잠시 후 다시 시도해 주세요.';
      });
      return;
    }

    final ProductDetailsResponse response = await _iap.queryProductDetails(
      _productIds,
    );
    if (!mounted) return;

    if (response.error != null) {
      setState(() {
        _isLoading = false;
        _storeAvailable = true;
        _errorMessage = '상품 조회 실패: ${response.error!.message}';
      });
      return;
    }

    final sortedProducts = [...response.productDetails]
      ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

    setState(() {
      _products = sortedProducts;
      _isLoading = false;
      _storeAvailable = true;
      if (response.notFoundIDs.isNotEmpty) {
        _errorMessage =
            '일부 상품이 App Store Connect에 등록되지 않았습니다: ${response.notFoundIDs.join(', ')}';
      } else if (sortedProducts.isEmpty) {
        _errorMessage = '기부 상품을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.';
      } else {
        _errorMessage = null;
      }
    });
  }

  Future<void> _purchase(ProductDetails product) async {
    if (_isPurchasing) return;

    setState(() {
      _isPurchasing = true;
    });

    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      final started = await _iap.buyConsumable(purchaseParam: purchaseParam);
      if (!started && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('결제를 시작하지 못했습니다. 잠시 후 다시 시도해 주세요.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('결제 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '결제 실패: ${purchaseDetails.error?.message ?? '알 수 없는 오류'}',
              ),
            ),
          );
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('기부해주셔서 감사합니다.')));
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('개발자에게 기부하기', style: TextStyle(fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '앱 사용에 도움이 되셨다면\n작은 기부로 응원해 주세요.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '기부는 인앱결제(IAP)로 처리되며 앱 기능에는 영향을 주지 않습니다.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Color(0xFF868E96),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3BF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFF495057),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _products.isNotEmpty
                        ? ListView.separated(
                            itemCount: _products.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return _DonateOptionTile(
                                title: product.title,
                                description: product.description,
                                price: product.price,
                                onTap: _isPurchasing
                                    ? null
                                    : () => _purchase(product),
                              );
                            },
                          )
                        : _DonateEmptyState(
                            isStoreAvailable: _storeAvailable,
                            onRetry: _loadStore,
                            showDebugFallback: kDebugMode,
                            fallbackProducts: _fallbackProducts,
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _DonateOptionTile extends StatelessWidget {
  const _DonateOptionTile({
    required this.title,
    required this.description,
    required this.price,
    required this.onTap,
  });

  final String title;
  final String description;
  final String price;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onTap == null ? const Color(0xFFF8F9FA) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: onTap == null
                            ? const Color(0xFFADB5BD)
                            : const Color(0xFF868E96),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                price,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: onTap == null ? const Color(0xFFADB5BD) : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallbackProduct {
  const _FallbackProduct({
    required this.title,
    required this.description,
    required this.price,
  });

  final String title;
  final String description;
  final String price;
}

class _DonateEmptyState extends StatelessWidget {
  const _DonateEmptyState({
    required this.isStoreAvailable,
    required this.onRetry,
    required this.showDebugFallback,
    required this.fallbackProducts,
  });

  final bool isStoreAvailable;
  final VoidCallback onRetry;
  final bool showDebugFallback;
  final List<_FallbackProduct> fallbackProducts;

  @override
  Widget build(BuildContext context) {
    if (!showDebugFallback) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isStoreAvailable
                  ? '기부 상품을 불러오는 중 문제가 발생했습니다.'
                  : 'App Store 연결이 필요합니다.',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                color: Color(0xFF495057),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: fallbackProducts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = fallbackProducts[index];
        return _DonateOptionTile(
          title: product.title,
          description: '${product.description} (디버그 미리보기)',
          price: product.price,
          onTap: null,
        );
      },
    );
  }
}

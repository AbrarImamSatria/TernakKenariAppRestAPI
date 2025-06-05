import 'package:canary_app/presentation/buyer/profile/bloc/profile_buyer_bloc.dart';
import 'package:canary_app/presentation/buyer/profile/widget/Profile_view_buyer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil profil pembeli saat halaman dimuat
    context.read<ProfileBuyerBloc>().add(GetProfileBuyerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Pembeli")),
      body: BlocListener<ProfileBuyerBloc, ProfileBuyerState>(
        listener: (context, state) {
          if (state is ProfileBuyerError || state is ProfileBuyerAddError) {
            // Tampilkan pesan kesalahan dari state
            final message = state is ProfileBuyerError
                ? state.message
                : (state as ProfileBuyerAddError).message;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );

            // Ambil ulang data profil
            context.read<ProfileBuyerBloc>().add(GetProfileBuyerEvent());
          }
        },
        child: BlocBuilder<ProfileBuyerBloc, ProfileBuyerState>(
          builder: (context, state) {
            if (state is ProfileBuyerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileBuyerLoaded && state.profile.data != null) {
              final profile = state.profile.data;
              return ProfileViewBuyer(profile: profile);
            }

            // Default ke form jika tidak ada data atau error
            return ProfileBuyerInputForm();
          },
        ),
      ),
    );
  }
}

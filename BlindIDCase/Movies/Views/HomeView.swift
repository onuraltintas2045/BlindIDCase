//
//  HomeView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                //LazyVStack kullanıldığında KingFisher görseller için her ekrana girdiğinde istek atıyor.
                //Veri sayısı az ve api pagination yapısına sahip değil. O sebeple VStack şu an için uygun.
                VStack(spacing: 16) {
                    ForEach(viewModel.movies) { movie in
                        MovieCardView(movie: movie)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .padding(.bottom)
            .background(Color.black.opacity(0.3))
            .navigationTitle("Movies")
            .onAppear {
                viewModel.fetchMoviesIfNeeded()
            }
        }
        
    }
}

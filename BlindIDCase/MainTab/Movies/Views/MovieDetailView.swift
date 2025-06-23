//
//  MovieDetailView.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel: MovieDetailViewModel
    @State private var isFavorite: Bool = false
    @State private var isPressed = false
    @State private var buttonName: ClickedButton = .none
    
    // MARK: - Init
    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - MovieImage
                    HStack {
                        KFImage(URL(string: viewModel.movie.posterUrl))
                            .resizable()
                            .cancelOnDisappear(true)
                            .placeholder {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 450)
                                    .foregroundColor(.clear)
                            }
                            .frame(width: 300, height: 450)
                            .scaledToFit()
                            .cornerRadius(12)
                            .shadow(radius: 6)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // MARK: - Movie Information
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("📅 \(String(viewModel.movie.year))")
                            Text("🎭 \(viewModel.movie.category)")
                            Text("⭐️ \(String(format: "%.1f", viewModel.movie.rating))")
                        }
                        .font(.subheadline)
                        .foregroundColor(.black)
                    }
                    .padding(.horizontal)

                    Divider()
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline)
                        Text(viewModel.movie.description)
                            .font(.body)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Actors")
                            .font(.headline)
                        ForEach(viewModel.movie.actors, id: \.self) { actor in
                            Text("• \(actor)")
                                .font(.body)
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Favorite Button
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.1)) {
                            buttonName = .addFavorite
                            isPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeOut(duration: 0.1)) {
                                isPressed = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                viewModel.toggleFavorite()
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: viewModel.movie.isLiked ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.movie.isLiked ? .red : .primary)
                            Text(viewModel.movie.isLiked ? "Unfavorite" : "Add Favorite")
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .scaleEffect((isPressed && buttonName == .addFavorite) ? 0.8 : 1.0)

                }
                .padding(.vertical)
            }
            .background(Color.black.opacity(0.1))
            .allowsHitTesting(!viewModel.isProcessing)
            
            if viewModel.isProcessing {
                LoadingOverlayView()
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
}

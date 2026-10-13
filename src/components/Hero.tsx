import React from 'react';

const Hero: React.FC = () => {
  return (
    <section className="relative bg-gradient-to-br from-blue-50 to-white py-20 px-4">
      <div className="max-w-4xl mx-auto text-center">
        <h1 className="text-5xl md:text-6xl font-blueprint font-semibold text-blueprint-primary mb-6 animate-fade-in">
          Crafted Coffee, Fresh Plates, Cozy Vibes
          <span className="block text-blue-600 mt-2">Blueprint Cafe</span>
        </h1>
        <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto animate-slide-up">
          Specialty drinks, comforting dishes, and signature blends made daily.
        </p>
        <div className="flex justify-center">
          <a 
            href="#ramen"
            className="bg-blue-600 text-white px-8 py-3 rounded-full hover:bg-blue-700 transition-all duration-300 transform hover:scale-105 font-medium"
          >
            Explore Menu
          </a>
        </div>
      </div>
    </section>
  );
};

export default Hero;
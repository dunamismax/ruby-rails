class HomeController < ApplicationController
  def index
    @posts = [
      {
        title: "Welcome to Dunamismax",
        excerpt: "This is my personal blog and portfolio website. Here I share my thoughts on technology, programming, and life.",
        date: Date.current,
        slug: "welcome-to-dunamismax"
      },
      {
        title: "Building a Ruby on Rails Monorepo",
        excerpt: "Learn how to structure a Ruby on Rails monorepo for maximum productivity and maintainability.",
        date: 1.week.ago,
        slug: "building-ruby-rails-monorepo"
      },
      {
        title: "My Journey in Software Development",
        excerpt: "From beginner to professional developer, this is my story and the lessons I've learned along the way.",
        date: 2.weeks.ago,
        slug: "my-journey-in-software-development"
      }
    ]
  end

  def about
  end

  def contact
  end
end
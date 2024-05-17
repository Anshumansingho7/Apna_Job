# Stage 1: Build dependencies
ARG RUBY_VERSION=3.0.0
FROM ruby:$RUBY_VERSION as build

WORKDIR /rails

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    default-libmysqlclient-dev \
    git \
    libvips \
    pkg-config
    
# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Stage 2: Final image for app
FROM ruby:$RUBY_VERSION

WORKDIR /rails

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl default-mysql-client libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]





class AdminMailer < ApplicationMailer
  def otp_email
    @admin = params[:admin]
    @otp = params[:otp]
    mail(to: 'fixed@example.com', subject: 'OTP for Admin Registration')
  end
end



def verify_otp
    admin = Admin.find(params[:admin_id])
    if params[:otp] == admin.otp
      admin.update(otp: nil) 
      redirect_to edit_admin_registration_path, notice: "OTP verified successfully."
    else
      admin.destroy
      redirect_to new_admin_session_path, alert: "Incorrect OTP."
    end
  end

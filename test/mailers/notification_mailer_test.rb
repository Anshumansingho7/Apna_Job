require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  test "registration" do
    mail = NotificationMailer.registration
    assert_equal "Registration", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "password_change" do
    mail = NotificationMailer.password_change
    assert_equal "Password change", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "job_approved" do
    mail = NotificationMailer.job_approved
    assert_equal "Job approved", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "job_rejected" do
    mail = NotificationMailer.job_rejected
    assert_equal "Job rejected", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

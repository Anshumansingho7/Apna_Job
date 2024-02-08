module ApplicationHelper
    def attach(logo)
        image_tag attachments[logo].url
    end
end

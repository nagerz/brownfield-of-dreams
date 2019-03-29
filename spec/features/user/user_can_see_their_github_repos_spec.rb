# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User can see their Github repositories' do
  describe 'As a logged in user, in my dashboard' do
    describe "If I don't have a github token" do
      it "I don't see a github section" do
        filename = 'user_1_github_repos.json'
        url = 'https://api.github.com/user/repos'

        stub_get_json(url, filename)

        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit '/dashboard'

        expect(page).to_not have_content('Github')
      end
    end

    describe 'under the Github section' do
      it 'I see a list of 5 repositories' do
        stub_user_1_dashboard

        user = create(:user)
        create(:github_token, user: user, token: ENV['USER_1_GITHUB_TOKEN'])
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit '/dashboard'

        expect(page).to have_content('Github')

        expect(page).to have_css('.user_repo', count: 5)

        within(first('.user_repo')) do
          expect(page).to have_css('.name')
          expect(page).to have_link('activerecord-obstacle-course', href: 'https://github.com/teresa-m-knowles/activerecord-obstacle-course')
        end
      end

      it 'a second user sees their repositories' do
        stub_user_2_dashboard

        user1 = create(:user)
        create(:github_token, user: user1, token: ENV['USER_1_GITHUB_TOKEN'])
        user2 = create(:user)
        create(:github_token, user: user2, token: ENV['USER_2_GITHUB_TOKEN'])

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)

        visit '/dashboard'

        expect(page).to have_content('Github')

        expect(page).to have_css('.user_repo', count: 5)

        within(first('.user_repo')) do
          expect(page).to have_css('.name')
          expect(page).to have_link('activerecord-obstacle-course', href: 'https://github.com/nagerz/activerecord-obstacle-course')
        end
      end
    end
  end
end

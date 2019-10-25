require 'rails_helper'

describe IcuRating do
  describe "list", js: true do
    before(:each) do
      @r1 = FactoryGirl.create(:icu_rating, list: "2011-09-01", full:true,  icu_player: FactoryGirl.create(:icu_player, club: "Bangor", fed: "IRL"))
      @r2 = FactoryGirl.create(:icu_rating, list: "2011-09-01", full:false, icu_player: FactoryGirl.create(:icu_player, club: "Galway", fed: "IRL", gender: "F"))
      @r3 = FactoryGirl.create(:icu_rating, list: "2011-09-01", full:true,  icu_player: FactoryGirl.create(:icu_player, club: nil,      fed: "SCO"))
      @r4 = FactoryGirl.create(:icu_rating, list: "2011-05-01", full:true,  icu_player: FactoryGirl.create(:icu_player, club: nil,      fed:  nil ))
      @r5 = FactoryGirl.create(:icu_rating, list: "2011-05-01", full:false, icu_player: @r1.icu_player)
      @xp = "#icu_rating_results table tr"
    end

    it "unfiltered" do
      visit icu_ratings_path
      expect(page).to have_selector(@xp, count: 6)
    end

    it "rating list" do
      visit icu_ratings_path
      page.select "2011 Sep", from: "list"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 4)
    end

    it "club - Any list" do
      visit icu_ratings_path
      page.select "Any", from: "list"
      page.select "Bangor", from: "club"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 3)
    end

    it "club - Specific list" do
      visit icu_ratings_path
      page.select "2011 Sep", from: "list"
      page.select "Bangor", from: "club"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 2)
    end

    it "gender" do
      visit icu_ratings_path
      page.select "Any", from: "list"
      page.select "Male", from: "gender"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 5)
      page.select "Female", from: "gender"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 2)
    end

    it "federation" do
      visit icu_ratings_path
      page.select "Any", from: "list"
      page.select "Ireland", from: "fed"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 4)
      page.select "Scotland", from: "fed"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 2)
      page.select "Ireland or Unknown", from: "fed"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 5)
    end

    it "ICU ID" do
      visit icu_ratings_path
      page.select "Any", from: "list"
      page.fill_in "ICU ID", with: @r1.icu_player.id
      click_button "Search"
      expect(page).to have_selector(@xp, count: 3)
    end

    it "full or provisional" do
      visit icu_ratings_path
      page.select "Any", from: "list"
      page.select "Full", from: "type"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 4)
      page.select "Provisional", from: "type"
      click_button "Search"
      expect(page).to have_selector(@xp, count: 3)
    end
  end
end

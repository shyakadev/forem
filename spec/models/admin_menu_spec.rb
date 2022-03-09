require "rails_helper"

RSpec.describe AdminMenu do
  describe ".navigation_items" do
    subject(:navigation_items) { described_class.navigation_items }

    it { is_expected.to be_a(Hash) }
  end

  describe "scope :content_manager" do
    subject(:content_manager) { described_class.navigation_items.fetch(:content_manager) }

    it { is_expected.to be_a(Menu::Scope) }
  end

  describe "scope :content_managers's posts item" do
    subject(:posts) { content_manager.children.detect { |child| child.name == "posts" } }

    let(:content_manager) { described_class.navigation_items.fetch(:content_manager) }

    it { is_expected.to be_visible }
  end

  describe "scope :customization" do
    subject(:content_manager) { described_class.navigation_items.fetch(:customization) }

    it { is_expected.to be_a(Menu::Scope) }
    it { is_expected.to have_multiple_children }
    it { is_expected.to have_children }
  end

  describe "scope :admin_team" do
    subject(:content_manager) { described_class.navigation_items.fetch(:admin_team) }

    it { is_expected.not_to have_multiple_children }
    it { is_expected.to have_children }
  end

  describe "scope :customization's profile field" do
    subject(:profile_field) { customization.children.detect { |child| child.name == "profile fields" } }

    let(:customization) { described_class.navigation_items.fetch(:customization) }

    it { is_expected.to be_a(Menu::Item) }

    context "when :profile_field FeatureFlag is enabled" do
      before { allow(FeatureFlag).to receive(:enabled?).with(:profile_admin).and_return(true) }

      it { is_expected.to be_visible }
    end

    context "when :profile_field FeatureFlag is not enabled" do
      before { allow(FeatureFlag).to receive(:enabled?).with(:profile_admin).and_return(false) }

      it { is_expected.not_to be_visible }
    end
  end
end

# -*- encoding : utf-8 -*-
class Member < ActiveRecord::Base

  include Tokyorails::GithubMethods

  validates_presence_of :uid, :name, :bio
  validates_uniqueness_of :uid
  validates_uniqueness_of :github_username, :allow_blank => true

  has_one :image, :dependent => :destroy

  scope :authenticated, where('access_token is not null')
  scope :name_like, lambda {|query| where("name  LIKE ?", "%#{query}%")}

  def self.authenticate(auth)
    member = Member.find_by_uid(auth['uid'])
    if member
      member.access_token = auth['credentials']['token']
      member.save!
    end
    member
  end

  def photo
    self.image || self.create_image(:file_url => photo_url) unless photo_url.blank?
  end

  def interests
    [] # coming from somewhere
  end

end

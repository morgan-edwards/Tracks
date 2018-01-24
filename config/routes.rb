require_relative 'router'

DefaultRouter = Router.new
DefaultRouter.draw do
  get Regexp.new("^/$"), DefaultController, :index
end

require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  test  'get new category from and create category' do
    get new_category_path
    assert_template 'categories/new'
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: "sports" } }
      follow_redirect! # This is necessary or it falls apart
      # Source: https://stackoverflow.com/questions/44521001/ror-testing-errors-expecting-categories-new-but-rendering-with
    end

    # Something wrong with these:
    assert_template 'categories/index'
    assert_match 'sports', response.body
  end

  test "invalid category submission results in failure" do
    get new_category_path
    assert_template 'categories/new'
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: " " } }
      # follow_redirect! # This is necessary or it falls apart
      # Source: https://stackoverflow.com/questions/44521001/ror-testing-errors-expecting-categories-new-but-rendering-with
    end

    # Something wrong with these
    assert_template 'categories/new'
    assert_select 'div.card-header'
    assert_select 'div.card-text'
  end
end
defmodule Ui.SlidesTest do
  use Ui.DataCase

  alias Ui.Slides

  describe "slides" do
    alias Ui.Slides.Slide

    import Ui.SlidesFixtures

    @invalid_attrs %{order: nil, content: nil}

    test "list_slides/0 returns all slides" do
      slide = slide_fixture()
      assert Slides.list_slides() == [slide]
    end

    test "get_slide!/1 returns the slide with given id" do
      slide = slide_fixture()
      assert Slides.get_slide!(slide.id) == slide
    end

    test "create_slide/1 with valid data creates a slide" do
      valid_attrs = %{order: 42, content: "some content"}

      assert {:ok, %Slide{} = slide} = Slides.create_slide(valid_attrs)
      assert slide.order == 42
      assert slide.content == "some content"
    end

    test "create_slide/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Slides.create_slide(@invalid_attrs)
    end

    test "update_slide/2 with valid data updates the slide" do
      slide = slide_fixture()
      update_attrs = %{order: 43, content: "some updated content"}

      assert {:ok, %Slide{} = slide} = Slides.update_slide(slide, update_attrs)
      assert slide.order == 43
      assert slide.content == "some updated content"
    end

    test "update_slide/2 with invalid data returns error changeset" do
      slide = slide_fixture()
      assert {:error, %Ecto.Changeset{}} = Slides.update_slide(slide, @invalid_attrs)
      assert slide == Slides.get_slide!(slide.id)
    end

    test "delete_slide/1 deletes the slide" do
      slide = slide_fixture()
      assert {:ok, %Slide{}} = Slides.delete_slide(slide)
      assert_raise Ecto.NoResultsError, fn -> Slides.get_slide!(slide.id) end
    end

    test "change_slide/1 returns a slide changeset" do
      slide = slide_fixture()
      assert %Ecto.Changeset{} = Slides.change_slide(slide)
    end
  end
end

class WordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  def index
    if params[:term].present?
      @words = Word.search_by_word(params[:term]).order(id: :desc).page params[:page]
    elsif params[:photo_source].present?
      @words = Word.not_unsplash.order(id: :desc).page params[:page]
    else 
      @words = Word.order(id: :desc).page params[:page]
    end
  end

  def show
  end

  def new
    @word = Word.new
  end

  def edit
  end

  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_word
      @word = Word.find(params[:id])
    end

    def word_params
      params.require(:word).permit(:word, :image, :grouping, :pronunciation, translations_attributes: [:id, :foreign_word, :foreign_pronunciation, :language_id, :_destroy])
    end
end

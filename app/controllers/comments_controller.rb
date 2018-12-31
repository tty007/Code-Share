class CommentsController < ApplicationController
    def create
      @code = Code.friendly.find(params[:code_id])
      @comment = @code.comments.build(comment_params)
      @comment.user_id = current_user.id
      if @comment.save
        redirect_to code_path(@code)
      else
        render "code/show"
      end
    end

    def destroy
      @comment = current_user.comments.find(params[:id])
      @comment.destroy
      flash[:notice] = 'コメントを削除しました'
      redirect_to code_path(id: @comment.code_id)
    end

    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
end

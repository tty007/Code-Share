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

    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
end

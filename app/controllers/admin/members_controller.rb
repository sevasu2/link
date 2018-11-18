class Admin::MembersController < Admin::Base
  before_action :login_required

    # 会員一覧
  def index
    @members = Member.all
    # if params[:name].present?
    #   @members = Member.search(params[:search])
    # end
    @members = @members.page(params[:page]).per(10)
  end

  # 検索
  def search
    if !params[:name].blank?
      @members = Member.where(["name LIKE ?", "%#{params[:name]}%"]).
        page(params[:page]).per(30) if params[:name].present?
    else
      @members = Member.order("created_at DESC").
        page(params[:page]).per(30)
    end
    render :action => "index"
  end

  # 会員情報の詳細
  def show
    @member = Member.find(params[:id])
  end

  # 新規作成フォーム
  def new
    @member = Member.new(birthday: Date.new(1980, 1,1))
  end

  # 編集フォーム
  def edit
    @member = Member.find(params[:id])
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to [:admin, @member], notice: "会員を登録しました。"
    else
      render "new"
    end
  end

  # 会員情報の更新
  def update
    @member = Member.find(params[:id])
    @member.assign_attributes(member_params)
    if @member.save
      redirect_to [:admin, @member], notice: "会員情報を更新しました。"
    else
      render "edit"
    end
  end

 # 会員の削除
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to :admin_members, notice: "会員を削除しました。"
  end

  # ストロング・パラメータ
  private def member_params
    attrs = [
      :new_profile_picture,
      :remove_profile_picture,
      :name,
      :sex,
      :birthday,
      :address,
      :email,
      :administrator
    ]

    attrs << :password if action_name == "create"

    params.require(:member).permit(attrs)
  end
end
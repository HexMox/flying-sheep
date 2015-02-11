window.title = '羊气冲天，中北明夷给您拜年了'
window.lineLink = location.origin + '/flyingsheep'
window.imgUrl = lineLink + '/assets/normal-sheep.png'
window.descContent = '...'

AGENT = window.navigator.userAgent

HEIGHT = document.documentElement.clientHeight
WIDTH = document.documentElement.clientWidth
MAX_HEIGHT = 568
MAX_WIDTH = 360
HEIGHT = if HEIGHT > MAX_HEIGHT then MAX_HEIGHT else HEIGHT
WIDTH = if WIDTH > MAX_WIDTH then MAX_WIDTH else WIDTH

# 图片的宽高比
SHEEP_IMG_RATE = 150 / 172
CLOUD_IMG_RATE = 71 / 41
# 羊宽度相对于云宽度的比例
SHEEP_TO_CLOUD_RATE = 0.8
# 两边的装饰墙占屏幕宽度的比例
SIDE_WALL_RATE = 0.1
# 除去装饰墙漂浮物的列数
COLUMN_COUNT = 6

# 漂浮物的默认宽高
DEFAULT_FLUTTER_WIDTH = WIDTH * (1 - SIDE_WALL_RATE) / COLUMN_COUNT
DEFAULT_FLUTTER_HEIGHT = DEFAULT_FLUTTER_WIDTH / CLOUD_IMG_RATE
# 网格宽高
GRID_WIDTH = DEFAULT_FLUTTER_WIDTH
GRID_HEIGHT = DEFAULT_FLUTTER_HEIGHT

DEFAULT_FLUTTER_WIDTH = Math.floor DEFAULT_FLUTTER_WIDTH 
DEFAULT_FLUTTER_HEIGHT = Math.floor DEFAULT_FLUTTER_HEIGHT

# 羊的默认宽高
DEFAULT_SHEEP_WIDTH = DEFAULT_FLUTTER_WIDTH * SHEEP_TO_CLOUD_RATE
DEFAULT_SHEEP_WIDTH = Math.floor DEFAULT_SHEEP_WIDTH
DEFAULT_SHEEP_HEIGHT = DEFAULT_SHEEP_WIDTH / SHEEP_IMG_RATE
DEFAULT_SHEEP_HEIGHT = Math.floor DEFAULT_SHEEP_HEIGHT

# 除去地面或计时条漂浮物的行数
ROW_COUNT = Math.floor(HEIGHT / DEFAULT_FLUTTER_HEIGHT) - 1
# 也是计时条和地面的高度
TIME_BAR_HEIGHT = GROUND_HEIGHT = HEIGHT - GRID_HEIGHT * ROW_COUNT 
# 每网格的米数
METER_PER_GRID = 10
# 羊正常跳的高度
ONE_RISE_HEIGHT = 180
# 将地面改成时间条的得分线
GROUND_TO_TIME_BAR_SCORE = 50
# 游戏时间
SECONDS = 180

# 产生漂浮物的策略
KINDS = ["white-cloud", "empty-cloud", "black-cloud", "red-packet"]
# 得分的基准线
BASE_LINE = Math.floor(HEIGHT - ONE_RISE_HEIGHT - DEFAULT_SHEEP_HEIGHT) + 1
STRATEGY = [{
    # score 0-50
    amountProbilities: [0.7, 0.2, 0.1]
    kindProbilities: [0.8, 0.2, 0, 0]
},{
    # score 51-1500
    amountProbilities: [0.7, 0.2, 0.1]
    kindProbilities: [0.6, 0.15, 0.1, 0.15]
},{
    # score 1501-5000
    amountProbilities: [0.7, 0.2, 0.1]
    kindProbilities: [0.5, 0.25, 0.15, 0.1]
},{
    # score 5000up
    amountProbilities: [0.7, 0.2, 0.1]
    kindProbilities: [0.4, 0.35, 0.2, 0.05]
}]

config = 
    AGENT: AGENT
    WIDTH: WIDTH
    HEIGHT: HEIGHT

    ONE_RISE_HEIGHT: ONE_RISE_HEIGHT
    METER_PER_GRID: METER_PER_GRID
    SIDE_WALL_RATE: SIDE_WALL_RATE

    COLUMN_COUNT: COLUMN_COUNT
    ROW_COUNT: ROW_COUNT 

    DEFAULT_FLUTTER_WIDTH: DEFAULT_FLUTTER_WIDTH 
    DEFAULT_FLUTTER_HEIGHT: DEFAULT_FLUTTER_HEIGHT 
    GRID_WIDTH: GRID_WIDTH
    GRID_HEIGHT: GRID_HEIGHT

    DEFAULT_SHEEP_WIDTH: DEFAULT_SHEEP_WIDTH
    DEFAULT_SHEEP_HEIGHT: DEFAULT_SHEEP_HEIGHT

    TIME_BAR_HEIGHT: TIME_BAR_HEIGHT
    GROUND_HEIGHT: GROUND_HEIGHT

    BASE_LINE: BASE_LINE
    GROUND_TO_TIME_BAR_SCORE: GROUND_TO_TIME_BAR_SCORE
    SECONDS: SECONDS

    KINDS: KINDS
    STRATEGY: STRATEGY

console.log config
module.exports = config
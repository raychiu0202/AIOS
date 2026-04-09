package cn.iocoder.aios.module.mes.dal.mysql.wm.packages;

import cn.iocoder.aios.framework.common.pojo.PageResult;
import cn.iocoder.aios.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.aios.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.aios.module.mes.controller.admin.wm.packages.vo.line.MesWmPackageLinePageReqVO;
import cn.iocoder.aios.module.mes.dal.dataobject.wm.packages.MesWmPackageLineDO;
import org.apache.ibatis.annotations.Mapper;

/**
 * MES 装箱明细 Mapper
 *
 * @author 芋道源码
 */
@Mapper
public interface MesWmPackageLineMapper extends BaseMapperX<MesWmPackageLineDO> {

    default PageResult<MesWmPackageLineDO> selectPage(MesWmPackageLinePageReqVO reqVO, java.util.Collection<Long> packageIds) {
        return selectPage(reqVO, new LambdaQueryWrapperX<MesWmPackageLineDO>()
                .inIfPresent(MesWmPackageLineDO::getPackageId, packageIds)
                .orderByDesc(MesWmPackageLineDO::getId));
    }

    default void deleteByPackageId(Long packageId) {
        delete(MesWmPackageLineDO::getPackageId, packageId);
    }

}
